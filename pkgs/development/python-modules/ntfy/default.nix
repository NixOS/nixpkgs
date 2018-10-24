{ stdenv
, buildPythonPackage
, fetchFromGitHub
, appdirs
, pyyaml
, requests
, dbus-python
, emoji
, sleekxmpp
, mock
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "ntfy";

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "0yjxwisxpxy3vpnqk9nw5k3db3xx6wyf6sk1px9m94s30glcq2cc";
  };

  propagatedBuildInputs = [ appdirs pyyaml requests dbus-python emoji sleekxmpp mock ];

  meta = with stdenv.lib; {
    description = "A utility for sending notifications, on demand and when commands finish";
    homepage = http://ntfy.rtfd.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kamilchm ];
  };

}
