{ stdenv
, buildPythonPackage
, fetchPypi
, django
, user-agents
}:

buildPythonPackage rec {
  pname = "django-user_agents";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "051m98z8n6lh159sn9fpj51hnmycdvsl6yd0cxl0xqyf8qhsxa6d";
  };

  doCheck = false;

  buildInputs = [ django user-agents ];

  meta = with stdenv.lib; {
    description = "A django package that allows easy identification of visitors' browser, operating system and device information";
    homepage = "https://github.com/selwin/django-user_agents";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };

}
