{
  version = "3.2.2";
  x86_64-linux = {
    platform = "manylinux1_x86_64";
    cpu = {
      cp312 = "sha256-9rO3PUesyCz1RYlublwxtVp/mibcCssoq8wkBp2Tlt0=";
      cp313 = "sha256-xPSFWWpobqcqsN3/yeQRePRWMUqZ1FOPXRgaAVapJ/o=";
    };
    gpu = {
      cu126 = {
        cp312 = "sha256-gY5/W2BR9+wVcPKdi5gZiHNH/t/rCv2g76rJ0E1wRt4=";
        cp313 = "sha256-CRNQl+8pRVbfJX172H2KNgsAeSiX+AYHoilMcw1pPXw=";
      };
      cu129 = {
        cp312 = "sha256-t2beVNEfz+JcesM5+i9BVNKKXIsI3zvz1VrTSd/79+c=";
        cp313 = "sha256-0thm6aAGpqSLfJdI0MZKuJPn2e4CsNU5S19ohzkukSs=";
      };
      cu130 = {
        cp312 = "sha256-70uOCNrFH9QB9G/0e5aAufBHPthJOjoJt39uprt68sE=";
        cp313 = "sha256-+aNoFQgqsrN9Jtqf0uChifIAacmbDdf8JkqjOqMsFpU=";
      };
    };
  };
  aarch64-linux = {
    platform = "manylinux2014_aarch64";
    cpu = {
      cp312 = "sha256-pZ2QILoWD6f1rvyzDkpjKTkKY10aC1EfZFgTk3bAP5k=";
      cp313 = "sha256-sDVpuhUaxQqnMJVcZd+lcf565x+UV0yU6L/l4JE6fZw=";
    };
  };
  aarch64-darwin = {
    platform = "macosx_11_0_arm64";
    cpu = {
      cp312 = "sha256-xi2rDU323il4lggy8AFaFFwjzTeUGNky3dj1RmKdH+Q=";
      cp313 = "sha256-9+m8BGnRPZmSXNdmxKbO61q2BDt5DdQVzgdvu+uzkHQ=";
    };
  };
}
