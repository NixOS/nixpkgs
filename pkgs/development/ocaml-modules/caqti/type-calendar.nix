{ lib, buildDunePackage, calendar, caqti }:

buildDunePackage {
  pname = "caqti-type-calendar";
  version = "1.2.0";
  useDune2 = true;
  inherit (caqti) src;

  propagatedBuildInputs = [ calendar caqti ];

  meta = caqti.meta // {
    description = "Date and time field types using the calendar library";
  };
}
