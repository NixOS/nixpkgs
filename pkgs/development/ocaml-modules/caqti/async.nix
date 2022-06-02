{ lib, buildDunePackage, async_kernel, async_unix, caqti, core_kernel }:

buildDunePackage {
  pname = "caqti-async";
  useDune2 = true;
  inherit (caqti) version src;

  propagatedBuildInputs = [ async_kernel async_unix caqti core_kernel ];

  meta = caqti.meta // { description = "Async support for Caqti"; };
}
