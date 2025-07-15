{
  lib,
  buildPythonPackage,
  replaceVars,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  wheel,
  capnproto,
  cython,
  pkgconfig,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "pycapnp";
    tag = "v${version}";
    hash = "sha256-SVeBRJMMR1Z8+S+QoiUKGRFGUPS/MlmWLi1qRcGcPoE=";
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
    (fetchpatch2 {
      name = "cython-3.patch";
      url = "https://github.com/capnproto/pycapnp/pull/334.diff?full_index=1";
      hash = "sha256-we7v4RaL7c1tePWl+oYfzMHAfnvnpdMkQgVu9YLwC6Y=";
    })
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

  meta = {
    description = "Cython wrapping of the C++ Cap'n Proto library";
    homepage = "https://capnproto.github.io/pycapnp/";
    changelog = "https://github.com/capnproto/pycapnp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Liamolucko ];
  };
}
