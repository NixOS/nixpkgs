{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, python3-application, lxml
, gevent, python3-eventlib }:

buildPythonPackage rec {
  pname = "python3-xcaplib";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = version;
    sha256 = "sha256-tIHDkseFkLqrdXFPSemYfOMRRhNcqJxCgMSr2xkI/DA=";
  };

  propagatedBuildInputs = [ lxml gevent python3-eventlib python3-application ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python XCAP client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      XCAP protocol, defined in RFC 4825, allows a client to read, write, and
      modify application configuration data stored in XML format on a server. XCAP
      maps XML document sub-trees and element attributes to HTTP URIs, so that
      these components can be directly accessed by HTTP. An XCAP server used by
      XCAP clients to store data like presence policy in combination with a SIP
      Presence server that supports PUBLISH/SUBSCRIBE/NOTIFY SIP methods can
      provide a complete SIP SIMPLE solution.

      The XCAP client example script provided by this package can be used to
      manage documents on an XCAP server.
    '';
  };
}
