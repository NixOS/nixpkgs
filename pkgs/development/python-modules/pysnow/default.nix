{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, poetry
, brotli
, ijson
, nose
, httpretty
, requests_oauthlib
, python_magic
, pytz
}:

buildPythonPackage rec {
  pname = "pysnow";
  version = "0.7.16";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "rbw";
    repo = pname;
    rev = version;
    sha256 = "0dj90w742klfcjnx7yhp0nzki2mzafqzzr0rk2dp6vxn8h58z8ww";
  };
  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'ijson = "^2.5.1"' 'ijson = "*"' \
      --replace 'pytz = "^2019.3"' 'pytz = "*"' \
      --replace 'oauthlib = "^3.1.0"' 'oauthlib = "*"'
  '';

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [
    brotli
    ijson
    python_magic
    pytz
    requests_oauthlib
  ];

  checkInputs = [ nose httpretty ];
  checkPhase = ''
    nosetests --cover-package=pysnow --with-coverage --cover-erase
  '';
  pythonImportsCheck = [ "pysnow" ];

  meta = with lib; {
    description = "ServiceNow HTTP client library written in Python";
    homepage = "https://github.com/rbw/pysnow";
    license = licenses.mit;
    maintainers = [ maintainers.almac ];
  };

}
