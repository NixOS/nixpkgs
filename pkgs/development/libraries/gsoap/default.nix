{ stdenv, fetchurl, unzip, m4, bison, flex, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "gsoap-${version}";
  version = "2.8.42";

  src = fetchurl {
    url = "mirror://sourceforge/project/gsoap2/gsoap-2.8/gsoap_${version}.zip";
    sha256 = "0fav4lhdibwggkf495pggmqna632jxkh6q2mi32b9hsn883pg5m7";
  };

  buildInputs = [ unzip m4 bison flex openssl zlib ];

  meta = with stdenv.lib; {
    description = "C/C++ toolkit for SOAP web services and XML-based applications";
    homepage = "http://www.cs.fsu.edu/~engelen/soap.html";
    # gsoap is dual/triple licensed (see homepage for details):
    # 1. gSOAP Public License 1.3 (based on Mozilla Public License 1.1).
    #    Components NOT covered by the gSOAP Public License are:
    #     - wsdl2h tool and its source code output,
    #     - soapcpp2 tool and its source code output,
    #     - UDDI code,
    #     - the webserver example code in gsoap/samples/webserver,
    #     - and several example applications in the gsoap/samples directory.
    # 2. GPLv2 covers all of the software
    # 3. Proprietary commercial software development license (removes GPL
    #    restrictions)
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
