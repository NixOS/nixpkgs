{ autonix, kdoctools }:

with autonix;

{
  manifestRules = [
    (addInput (input "gettext") "")
    (addInput (input "kf5archive") "")
    (addInput (input "pythoninterp") "")
  ];
}
