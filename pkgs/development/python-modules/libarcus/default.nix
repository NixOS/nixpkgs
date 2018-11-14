{ stdenv, buildPythonPackage, fetchFromGitHub
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "3.4.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "0mln8myvfl7rq2p4g1vadvlykckd8490jijag4xa5hhj3w3p19bk";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip protobuf ];
  nativeBuildInputs = [ cmake ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = https://github.com/Ultimaker/libArcus;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
