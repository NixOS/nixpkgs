{ autonix }:

with autonix.package;

{
  manifestRules = [
    (substInputs {
      pythoninterp = {
        name = "python";
        native = true;
        propagated = true;
      };
      gettext = {
        native = true;
        propagated = true;
      };
    })
  ];
}
