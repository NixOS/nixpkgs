{ stdenv
, lib
, fetchPypi
, fetchNuGet
, buildPythonPackage
, pytestCheckHook
, pycparser
, psutil
, pkg-config
, dotnetbuildhelpers
, clang
, glib
, mono
}:

let

  dotnetPkgs = [
    (fetchNuGet {
      pname = "UnmanagedExports";
      version = "1.2.7";
      sha256 = "0bfrhpmq556p0swd9ssapw4f2aafmgp930jgf00sy89hzg2bfijf";
      outputFiles = [ "*" ];
    })
    (fetchNuGet {
      pname = "NUnit";
      version = "3.12.0";
      sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
      outputFiles = [ "*" ];
    })
    (fetchNuGet {
      pname = "System.ValueTuple";
      version = "4.5.0";
      sha256 = "00k8ja51d0f9wrq4vv5z2jhq8hy31kac2rg0rv06prylcybzl8cy";
      outputFiles = [ "*" ];
    })
  ];

in

buildPythonPackage rec {
  pname = "pythonnet";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qzdc6jd7i9j7p6bcihnr98y005gv1358xqdr1plpbpnl6078a5p";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'self._install_packages()' '#self._install_packages()'
  '';

  preConfigure = ''
    [ -z "''${dontPlacateNuget-}" ] && placate-nuget.sh
    [ -z "''${dontPlacatePaket-}" ] && placate-paket.sh
  '';

  nativeBuildInputs = [
    pycparser

    pkg-config
    dotnetbuildhelpers
    clang

    mono

  ] ++ dotnetPkgs;

  buildInputs = [
    glib
    mono
  ];

  checkInputs = [
    pytestCheckHook
    psutil # needed for memory leak tests
  ];

  preBuild = ''
    rm -rf packages
    mkdir packages

    ${builtins.concatStringsSep "\n" (
        builtins.map (
            x: ''ln -s ${x}/lib/dotnet/${x.pname} ./packages/${x.pname}.${x.version}''
          ) dotnetPkgs)}

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    export TERM=xterm
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = ".Net and Mono integration for Python";
    homepage = "https://pythonnet.github.io";
    license = licenses.mit;
    # <https://github.com/pythonnet/pythonnet/issues/898>
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ jraygauthier ];
  };
}
