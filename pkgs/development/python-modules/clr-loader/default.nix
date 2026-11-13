{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonAtLeast,
  pytestCheckHook,
  dotnetCorePackages,
  setuptools,
  setuptools-scm,
  buildDotnetModule,
  cffi,
}:

let
  pname = "clr-loader";
  version = "0.3.1";
  src = fetchPypi {
    pname = "clr_loader";
    inherit version;
    hash = "sha256-Lgc+mq9J0a4vVuy6J5h61ftovkvNndNKW+2PDk4Sg2Y=";
  };
  # This stops msbuild from picking up $version from the environment
  postPatch = ''
    echo '<Project><PropertyGroup><Version/></PropertyGroup></Project>' > \
      Directory.Build.props
  '';

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit
      pname
      version
      src
      postPatch
      ;
    projectFile = [
      "netfx_loader/ClrLoader.csproj"
      "example/example.csproj"
    ];
    nugetDeps = ./deps.json;
    dotnet-sdk = dotnetCorePackages.sdk_10_0;
  };
in
buildPythonPackage {
  inherit
    pname
    version
    src
    postPatch
    ;

  disabled = pythonAtLeast "3.14";

  pyproject = true;

  buildInputs = dotnetCorePackages.sdk_10_0.packages ++ dotnet-build.nugetDeps;

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ dotnetCorePackages.sdk_10_0 ];

  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # TODO: mono does not work due to https://github.com/NixOS/nixpkgs/issues/7307
    "test_mono"
    "test_mono_debug"
    "test_mono_signal_chaining"
    "test_mono_set_dir"
  ];

  # Perform dotnet restore based on the nuget-source
  preConfigure = ''
    dotnet restore "netfx_loader/ClrLoader.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true

    dotnet restore "example/example.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true
  '';

  passthru = {
    inherit (dotnet-build) fetch-deps;
    # update-python-libraries only bumps version and hash, leaving deps.json and postPatch stale
    skipBulkUpdate = true;
  };

  meta = {
    description = "Generic pure Python loader for .NET runtimes";
    homepage = "https://pythonnet.github.io/clr-loader/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdarocha ];
  };
}
