{
  lib,
  buildPythonPackage,
  replaceVars,
  fetchFromGitHub,
  setuptools,
  wheel,
  capnproto,
  cython,
  pkgconfig,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "pycapnp";
    tag = "v${version}";
    hash = "sha256-oRgO/FuNxNMSUla+jIypD/dAvFi27TkEfCHbqovhq9I=";
  };

  patches = [
    # pycapnp hardcodes /usr/include and /usr/local/include as the paths to search
    # for capnproto's built-in schemas in; replace them with the path to our copy of
    # capnproto.
    #
    # Theoretically, this mechanism could also be used to load capnproto schemas
    # exposed by other packages (e.g. capnproto-java), which we could support using
    # a setup hook; but in practice nobody seems to use this mechanism for anything
    # other than the builtin schemas (based on quick GitHub code search), so I don't
    # think it's worthwhile.
    (replaceVars ./include-paths.patch { inherit capnproto; })
  ];

  build-system = [
    setuptools
    wheel
    cython
    pkgconfig
  ];

  buildInputs = [ capnproto ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];
  __darwinAllowLocalNetworking = true;
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    enabledTestPaths=$PWD/test
    pushd "$out"
  '';
  postCheck = ''
    popd
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'.
    "test_ssl_async_example"
    "test_async_ssl_calculator_example"
  ];

  meta = {
    description = "Cython wrapping of the C++ Cap'n Proto library";
    homepage = "https://capnproto.github.io/pycapnp/";
    changelog = "https://github.com/capnproto/pycapnp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Liamolucko ];
  };
}
