{ buildPythonPackage
, diskcache
, fetchFromGitHub
, lib
, llama-cpp
, numpy
, pytestCheckHook
, setuptools
, stdenv
, typing-extensions
}:

buildPythonPackage rec {
  pname = "llama-cpp-python";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "llama-cpp-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-kUoc61tSS7ohAl7vIN6Yt/TV1RLQg45QZXpff/URImA=";
  };

  patches = [
    ./disable-llama-cpp-build.patch
    ./set-llamacpp-path.patch
  ];

  postPatch = ''
    substituteInPlace llama_cpp/llama_cpp.py \
      --subst-var-by llamaCppSharedLibrary "${llama-cpp}/lib/libllama${stdenv.hostPlatform.extensions.sharedLibrary}"

    substituteInPlace tests/test_llama.py \
      --subst-var-by llamaCppModels "${llama-cpp}/share/models"
  '';

  format = "pyproject";

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    diskcache
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires pydantic-settings which is broken
    "test_llama_server"

    # failing test due to regression in llama-cpp, see
    # https://github.com/abetlen/llama-cpp-python/commit/55efc9e6b2a07bffa5250903de79e5f4873ba73d
    "test_llama_cpp_tokenization"
    "test_llama_patch"
  ];

  meta = with lib; {
    description = "Python bindings for llama.cpp";
    homepage = "https://github.com/abetlen/llama-cpp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
