{newBuildOcamlJane, base}:

newBuildOcamlJane {
  name = "sexplib";
  hash = "1cj0sv7zwy6njckiszym57zjwdkay78r9fncblsacqijzsdjl6dd";

  propagatedBuildInputs = [ base ];

  meta.description = "Automated S-expression conversion";
}
