{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  numpy,
  h5py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "h5io";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "h5io";
    repo = "h5io";
    rev = "refs/tags/h5io-${version}";
    hash = "sha256-3mrHIkfaXq06mMzUwudRO81DWTk0TO/e15IQA5fxxNc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace "--cov-report=" ""  \
      --replace "--cov-branch" ""  \
      --replace "--cov=h5io" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    h5py
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "h5io" ];

  meta = with lib; {
    description = "Read and write simple Python objects using HDF5";
    homepage = "https://github.com/h5io/h5io";
    changelog = "https://github.com/h5io/h5io/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
