{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "0.50";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cfxzhfxdphlzj80vkd3h7m0mg5w7zhb8h6f5lmybliqdiv9vz20";
  };

  propagatedBuildInputs = [ moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
