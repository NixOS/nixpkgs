{ autonix }:

with autonix.package;

{
  manifestRules = [
    (manifest: manifest // {
      /* Extra inputs are incorrectly detected for extra-cmake-modules because
       * it contains CMake code to detect all those dependencies! It actually
       * depends on CMake only.
       */
      inputs = [(input "cmake")];
    })
  ];
}
