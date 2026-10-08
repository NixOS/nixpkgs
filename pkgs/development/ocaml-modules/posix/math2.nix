{
  buildDunePackage,
  posix-base,
}:

buildDunePackage {
  pname = "posix-math2";
  inherit (posix-base) src version;

  propagatedBuildInputs = [
    posix-base
  ];

  meta = posix-base.meta // {
    description = "Bindings for posix math";
  };
}
