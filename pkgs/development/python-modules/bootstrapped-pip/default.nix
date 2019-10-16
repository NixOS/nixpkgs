{ stdenv, python, fetchPypi, makeWrapper, unzip, makeSetupHook
, pipInstallHook
, setuptoolsBuildHook

}:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.33.6";
    format = "wheel";
    sha256 = "f4da1763d3becf2e2cd92a14a7c920f0f00eca30fdde9ea992c836685b9faf28";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "41.4.0";
    format = "wheel";
    sha256 = "8d01f7ee4191d9fdcd9cc5796f75199deccb25b154eba82d44d6a042cf873670";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "19.3";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "e100a7eccf085f0720b4478d3bb838e1c179b1e128ec01c0403f84e86e0e2dfb";
  };

  dontUseSetuptoolsBuild = true;

  # Should be propagatedNativeBuildInputs
  propagatedBuildInputs = [
    # Override to remove dependencies to prevent infinite recursion.
    (pipInstallHook.override{pip=null;})
    (setuptoolsBuildHook.override{setuptools=null; wheel=null;})
  ];

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '';

  postPatch = ''
    mkdir -p $out/bin
  '';

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ python ];

  installPhase = ''

    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip._internal import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';

}
