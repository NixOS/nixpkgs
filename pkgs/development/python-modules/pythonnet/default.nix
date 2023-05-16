<<<<<<< HEAD
{ lib
, fetchPypi
=======
{ stdenv
, lib
, fetchPypi
, fetchNuGet
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, pytestCheckHook
, pycparser
, psutil
<<<<<<< HEAD
, dotnet-sdk
, buildDotnetModule
, clr-loader
, setuptools
}:

let
  pname = "pythonnet";
  version = "3.0.2";
  src = fetchPypi {
    pname = "pythonnet";
    inherit version;
    sha256 = "sha256-LN0cztxkp8m9cRvj0P0MSniTJHQTncVKppe+3edBx0Y=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    nugetDeps = ./deps.nix;
  };
in
buildPythonPackage {
  inherit pname version src;

  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
    dotnet-sdk
  ];

  propagatedBuildInputs = [
    pycparser
    clr-loader
  ];

  pytestFlagsArray = [
    # Run tests using .NET Core, Mono is unsupported for now due to find_library problem in clr-loader
    "--runtime coreclr"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil # needed for memory leak tests
  ];

<<<<<<< HEAD
  # Perform dotnet restore based on the nuget-source
  preConfigure = ''
    dotnet restore \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      --source ${dotnet-build.nuget-source}
  '';

  # Rerun this when updating to refresh Nuget dependencies
  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = with lib; {
    description = ".NET integration for Python";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://pythonnet.github.io";
    license = licenses.mit;
    # <https://github.com/pythonnet/pythonnet/issues/898>
    badPlatforms = [ "aarch64-linux" ];
<<<<<<< HEAD
    maintainers = with maintainers; [ jraygauthier mdarocha ];
=======
    maintainers = with maintainers; [ jraygauthier ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
