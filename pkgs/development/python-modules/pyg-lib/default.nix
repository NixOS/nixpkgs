{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, ninja
, parallel-hashmap
, pytestCheckHook
, pythonOlder
, torch
, triton
}:

buildPythonPackage rec {
  pname = "pyg-lib";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pyg-lib";
    rev = "refs/tags/${version}";
    hash = "sha256-SE8Ui24s5Dq5lZbDoqdv8/ggxbVB9kl9+zBg9zTO3Jg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    parallel-hashmap
  ];

  propagatedBuildInputs = [
    # implicit dependency
    torch
  ];

  dontUseCmakeConfigure = true;

  passthru.optional-dependencies = {
    triton = [
      triton
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r pyg_lib
  '';

  pythonImportsCheck = [ "pyg_lib" ];

  meta = with lib; {
    description = "Low-Level Graph Neural Network Operators for PyG";
    homepage = "https://github.com/pyg-team/pyg-lib";
    changelog = "https://github.com/pyg-team/pyg-lib/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
