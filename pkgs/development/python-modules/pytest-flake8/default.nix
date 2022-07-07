{lib, buildPythonPackage, fetchPypi, pythonOlder, fetchpatch, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.7";

  disabled = pythonOlder "3.5";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0259761a903563f33d6f099914afef339c085085e643bee8343eb323b32dd6b";
  };

  # see https://github.com/tholo/pytest-flake8/pull/82/commits
  patches = [
    (fetchpatch {
      url = "https://github.com/tholo/pytest-flake8/commit/eda4ef74c0f25b856fe282742ea206b21e94c24c.patch";
      sha256 = "0kq0wshds00rk6wvkn6ccjrjyqxg7m9l7dlyaqw974asizw6byci";
    })
  ];

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/tholo/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
