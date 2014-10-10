{ autonix }:

with autonix;

{
  manifestRules = [
    (addInput (input "gettext") "")
    (addInput (input "pythoninterp") "")
  ];
}
