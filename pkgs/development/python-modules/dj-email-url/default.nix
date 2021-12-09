{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "dj-email-url";

  src = fetchFromGitHub {
     owner = "migonzalvar";
     repo = "dj-email-url";
     rev = "v1.0.2";
     sha256 = "1rdy4l6k5w1qmws00nc15qlg2jzrcp6zckvj8r5zw2gxszy2i1fb";
  };

  checkPhase = ''
    ${python.interpreter} test_dj_email_url.py
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/migonzalvar/dj-email-url";
    description = "Use an URL to configure email backend settings in your Django Application";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
