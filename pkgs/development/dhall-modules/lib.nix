{ lib }:

let
  # This is essentially the same thing as `lib.makeOverridable`, except storing
  # the override method in a method named `overridePackage` so that it's not
  # shadowed by the `override` method added by `callPackage`
  makePackageOverridable =
    f: args:
    let
      result = lib.makeOverridable f args;

      copyArgs = g: lib.setFunctionArgs g (lib.functionArgs f);

      overrideWith = update: args // (if lib.isFunction update then update args else update);

      overridePackage = copyArgs (update: makePackageOverridable f (overrideWith update));

    in
    result // { inherit overridePackage; };

in
lib
// {
  inherit makePackageOverridable;
}
