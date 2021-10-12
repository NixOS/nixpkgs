{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.4.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = pname;
    rev = version;
    sha256 = "sha256-cFYtJqZ/RjFbn9XlEy6ffxZ2djisajQAwjV/YR2f59Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytest
  ];

  patches = [
    # Switch to poetry-core, https://github.com/miketheman/pytest-socket/pull/74
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/miketheman/pytest-socket/commit/32519170e656e731d24b81770a170333d3efa6a8.patch";
      sha256 = "19ksgx77rsa6ijcbml74alwc5052mdqr4rmvqhlzvfcvv3676ig2";
    })
  ];

  # pytest-socket require network for majority of tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_socket" ];

  meta = with lib; {
    description = "Pytest Plugin to disable socket calls during tests";
    homepage = "https://github.com/miketheman/pytest-socket";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
