{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  dotnetCorePackages,
  setuptools,
  setuptools-scm,
  wheel,
  buildDotnetModule,
  cffi,
}:

let
  pname = "clr-loader";
  version = "0.2.10";
  src = fetchPypi {
    pname = "clr_loader";
    inherit version;
    hash = "sha256-gfEUr7xQBbr8Xv5a8TQdQA4iE34nWwQqiXnz/rn8lEY=";
  };
  # This stops msbuild from picking up $version from the environment
  postPatch = ''
    echo '<Project><PropertyGroup><Version/></PropertyGroup></Project>' > \
      Directory.Build.props

    # The netfx_loader builds Windows-only .NET Framework DLLs (net472)
    # which are not needed on Linux
    substituteInPlace setup.py \
      --replace-fail 'dotnet_libs = [' 'dotnet_libs = []; _dotnet_libs = ['
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
      "example/example.csproj"
    ];
    nugetDeps = ./deps.json;
    dotnet-sdk = dotnetCorePackages.sdk_8_0;
  };
in
buildPythonPackage {
  inherit
    pname
    version
    src
    postPatch
    ;

  pyproject = true;

  buildInputs = dotnet-build.nugetDeps;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
    dotnetCorePackages.sdk_8_0
  ]
  ++ dotnetCorePackages.sdk_8_0.packages;

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # TODO: mono does not work due to https://github.com/NixOS/nixpkgs/issues/7307
    "test_mono"
    "test_mono_debug"
    "test_mono_signal_chaining"
    "test_mono_set_dir"
    # Pickling error with Python 3.13 multiprocessing
    "test_coreclr_properties"
  ];

  # Perform dotnet restore based on the nuget-source
  preConfigure = ''
    dotnet restore "example/example.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true
  '';

  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = {
    description = "Generic pure Python loader for .NET runtimes";
    homepage = "https://pythonnet.github.io/clr-loader/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdarocha ];
  };
}
