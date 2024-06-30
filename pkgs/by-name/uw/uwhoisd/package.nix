{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uwhoisd";
  version = "0.1.0-unstable-2024-02-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "uwhoisd";
    rev = "31ce5e83b8fcf200098fd5120d9c856f3f80e3f7";
    hash = "sha256-lnPGKF9pJ2NFIsx4HFdRip6R+vGVr9TYzvU89iwBc5g=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "tornado"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    publicsuffix2
    redis
    tornado
  ] ++ redis.optional-dependencies.hiredis;

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Universal WHOIS proxy server";
    homepage = "https://github.com/Lookyloo/uwhoisd";
    changelog = "https://github.com/Lookyloo/uwhoisd/blob/${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
