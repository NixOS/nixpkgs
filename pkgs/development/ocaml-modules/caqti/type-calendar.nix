{ lib, buildDunePackage, calendar, caqti }:

buildDunePackage {
  pname = "caqti-type-calendar";
  inherit (caqti) src version;

  propagatedBuildInputs = [ calendar caqti ];

  meta = caqti.meta // {
    description = "Date and time field types using the calendar library";
  };
}
