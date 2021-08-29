{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchpatch
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mutesync";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05r8maq59glwgysg98y1vrysfb1mkh9jpbag3ixl13n8jw8clp85";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  patches = [
    # Don't parse requirements.txt, https://github.com/currentoor/pymutesync/pull/1
    (fetchpatch {
      name = "add-requirements.patch";
      url = "https://github.com/currentoor/pymutesync/commit/d66910fc83b1ae3060cdb3fe22a6f91fb70a67f0.patch";
      sha256 = "0axhgriyyv31b1r1yidxcrv0nyrqbb63xw5qrmv2iy2h0v96ijsk";
    })
  ];

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "mutesync" ];

  meta = with lib; {
    description = "Python module for interacting with mutesync buttons";
    homepage = "https://github.com/currentoor/pymutesync";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
