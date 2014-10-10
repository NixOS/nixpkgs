{ autonix }:

with autonix;

{
  manifestRules = [
    (addInput (input "gettext") "")
    (addInput (input "pythoninterp") "")
    (addInput (input "karchive") "")
    (addInput (input "kwindowsystem") "")
  ];
}
