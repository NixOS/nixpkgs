{
  buildDunePackage,
  posix-base,
}:

buildDunePackage {
  pname = "posix-errno";

  inherit (posix-base) version src;

  propagatedBuildInputs = [
    posix-base
  ];

  doCheck = true;

  meta = posix-base.meta // {
    description = "Posix-errno provides comprehensive errno handling";
  };
}
