{ lib, buildPythonPackage, fetchFromGitHub, aiohttp, jinja2, pytest, pytest-aiohttp, pytest-cov }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.5";

  src = fetchFromGitHub {
     owner = "aio-libs";
     repo = "aiohttp_jinja2";
     rev = "v1.5";
     sha256 = "0f2qxzsjd0jqgd7zzmc0n9j4pknx4axfpsj6ldpfhpmxb4dczyjs";
  };

  propagatedBuildInputs = [ aiohttp jinja2 ];

  checkInputs = [ pytest pytest-aiohttp pytest-cov ];

  checkPhase = ''
    pytest -W ignore::DeprecationWarning
  '';

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp_jinja2";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
