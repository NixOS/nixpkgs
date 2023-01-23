{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, lwt
, alcotest
}:

buildDunePackage rec {
  pname = "mirage-runtime";
  inherit (functoria-runtime) src version;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ ipaddr functoria-runtime fmt logs lwt ];
  nativeCheckInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage";
    description = "The base MirageOS runtime library, part of every MirageOS unikernel";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
