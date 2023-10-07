{ buildDunePackage
, zelus
, lablgtk
}:

buildDunePackage {
  pname = "zelus-gtk";
  inherit (zelus) version src postPatch;

  minimalOCamlVersion = "4.08.1";

  nativeBuildInputs = [
    zelus
  ];

  buildInputs = [
    lablgtk
  ];

  meta = {
    description = "Zelus GTK library";
    inherit (zelus.meta) homepage license maintainers;
  };
}
