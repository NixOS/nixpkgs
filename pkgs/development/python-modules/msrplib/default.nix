{ stdenv
, buildPythonPackage
, fetchFromGitHub
, eventlib
, application
, gnutls
}:

buildPythonPackage rec {
  pname = "python-msrplib";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-/etzjVmafexXn4Xp6+o/xNmxRESmI5zAecXF7YSL4r4=";
  };

  propagatedBuildInputs = [ eventlib application gnutls ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AGProjects/python-msrplib;
    description = "Client library for MSRP protocol and its relay extension (RFC 4975 and RFC4976)";
    license = licenses.lgpl3;
  };

}
