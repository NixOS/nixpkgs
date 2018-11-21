{ stdenv
, buildPythonPackage
, fetchFromGitHub
, appdirs
, ruamel_yaml
, requests
, emoji
, sleekxmpp
, mock
, psutil
, python
# , dbus-python
}:

buildPythonPackage rec {
  version = "2.6.0";
  pname = "ntfy";

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "0hnwrybbk0gw0c6kw2zpx0x1rh3jb9qyrprcphzkv0jlhzdfkrp1";
  };

  propagatedBuildInputs = [ requests ruamel_yaml appdirs mock sleekxmpp emoji psutil ];

  checkPhase = ''
    HOME=$(mktemp -d) ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "A utility for sending notifications, on demand and when commands finish";
    homepage = http://ntfy.rtfd.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kamilchm ];
  };

}
