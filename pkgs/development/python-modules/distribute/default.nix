{ stdenv, buildPythonPackage, fetchPypi
, python, bootstrapped-pip
, setuptools }:

buildPythonPackage rec {
  pname = "distribute";
  version = "0.7.3";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0plc2dkmfd6p8lsqqvl1rryz03pf4i5198igml72zxywb78aiirx";
  };

  buildInputs = [
    setuptools
  ];

  installPhase = ''
    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    mkdir -p dist
    pushd dist

    ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache --build tmpbuild ..
    popd
  '';

  # No tests/ folder
  doCheck = false;

  meta = with stdenv.lib; {
    description = "distribute legacy wrapper";
    homepage = "https://pypi.org/project/distribute";
    license = [
      licenses.psfl
    ];
  };
}
