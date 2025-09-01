{
  buildDunePackage,
  async_kernel,
  async_unix,
  caqti,
  core_kernel,
}:

buildDunePackage {
  pname = "caqti-async";
  inherit (caqti) version src;

  minimalOCamlVersion = "5.0";

  propagatedBuildInputs = [
    async_kernel
    async_unix
    caqti
    core_kernel
  ];

  meta = caqti.meta // {
    description = "Async support for Caqti";
  };
}
