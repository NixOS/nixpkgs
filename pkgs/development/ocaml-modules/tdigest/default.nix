{ lib, fetchFromGitHub, buildDunePackage
, core
}:

buildDunePackage rec {
  pname = "tdigest";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "SGrondin";
    repo = pname;
    rev = version;
    sha256 = "sha256-R1uaCN/6NiW+jdGQiflwfihaidngvaWjJM7UFyR4vxs=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    core
  ];

  meta = with lib; {
    homepage = "https://github.com/SGrondin/${pname}";
    description = "OCaml implementation of the T-Digest algorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
