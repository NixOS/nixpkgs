{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "semaphore-compat";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/semaphore-compat/releases/download/${version}/semaphore-compat-${version}.tbz";
    sha256 = "139c5rxdp4dg1jcwyyxvhxr8213l1xdl2ab0mc288rfcppsiyxrb";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Compatibility Semaphore module";
    homepage = "https://github.com/mirage/semaphore-compat";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.sternenseemann ];
  };
}
