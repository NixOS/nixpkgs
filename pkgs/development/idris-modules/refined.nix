{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "refined";
  version = "2017-12-28";

  ipkgName = "idris-refined";

  src = fetchFromGitHub {
    owner = "janschultecom";
    repo = "idris-refined";
    rev = "e21cdef16106a77b42d193806c1749ba6448a128";
    sha256 = "1am7kfc51p2zlml954v8cl9xvx0g0f1caq7ni3z36xvsd7fh47yh";
  };

  meta = {
    description = "Port of Scala/Haskell Refined library to Idris";
    homepage = "https://github.com/janschultecom/idris-refined";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
