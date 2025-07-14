{
  buildDunePackage,
  posix-base,
  unix-errno,
}:

buildDunePackage {
  pname = "posix-math2";
  inherit (posix-base) src version;

  propagatedBuildInputs = [
    posix-base
    unix-errno
  ];

  meta = posix-base.meta // {
    description = "Bindings for posix math";
  };
}
