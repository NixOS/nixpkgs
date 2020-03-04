{ lib, buildDunePackage, fetchzip }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "13ahqaga1palf0s0dll512cl7k43sllmwvw6r03y70kfmky1j114";
  };

  doCheck = true;

  meta = with lib; {
    description = "Library for multicore parallel programming";
    homepage = "https://rdicosmo.github.io/parmap";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
