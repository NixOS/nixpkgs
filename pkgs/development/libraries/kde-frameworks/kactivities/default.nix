{ autonix }:

with autonix.package;

{
  manifestRules = [
    (addInputs [
      (input "boost")
      (input "kcmutils")
    ])
  ];
}
