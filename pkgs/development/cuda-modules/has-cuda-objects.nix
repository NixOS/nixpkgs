{
  lib,
  config,
  runCommand,
  cudaPackages,
  fd,
}:
{
  package,
  hasPTX ? false,
  requiredCapabilities ? [ ],
  preferLocalBuild ? true,
  ...
}@args:

assert lib.assertMsg (lib.isDerivation package) "provided package is not a derivation";

# `find` will search the whole store if this list is empty
assert lib.assertMsg (package.outputs != [ ]) "provided package has no outputs";

assert lib.assertMsg (args.__structuredAttrs or true
) "This test requires __structuredAttrs to be true";

let

  args' = lib.removeAttrs args [ "package" ];

  inherit (cudaPackages.flags) dropDot;

in

runCommand "test-any-cuobjdump-${package.name}"
  (
    args'
    // {
      inherit preferLocalBuild;
      nativeBuildInputs = args'.nativeBuildInputs or [ ] ++ [
        cudaPackages.cuda_cuobjdump
      ];

      __structuredAttrs = true;
      package_outputs = lib.forEach package.outputs (output: package.${output});
    }
  )
  ''
    #set -x
    any_cuobj_found=false
    while IFS= read -r -d "" fname; do
      echo "Checking $fname"

      failed=false
      cuobjdump_output=$(cuobjdump "$fname" 2>&1 || failed=true)

      if ! $failed && ! grep <<<"$cuobjdump_output" -q "does not contain device code"; then
        echo "Found cuda objects in $fname"
        any_cuobj_found=true

        # we could `continue`, but this is way better when debugging
        all_requirements_found=true

        # TODO: does this work?
        ${lib.optionalString hasPTX ''
          # we run cuobjdump again since --list-ptx interferes with requiredCapabilities
          if cuobjdump --list-ptx "$fname" 1>/dev/null 2>/dev/null; then
            echo "  Has PTX"
          else
            echo "  Does NOT have PTX"
            all_requirements_found=false
          fi
        ''}

        ${
          lib.concatLines (
            lib.forEach requiredCapabilities (cap: ''
              if grep <<<"$cuobjdump_output" -q "^arch = sm_${dropDot cap}$"; then
                echo "  Has architecture sm_${dropDot cap}"
              else
                echo "  Does NOT have architecture sm_${dropDot cap}!"
                all_requirements_found=false
              fi
            '')
          )
        }

        if ! "$all_requirements_found"; then
          continue
        fi

        touch $out
        break
      fi

    done < <(
      find "''${package_outputs[@]}" -type f -and \( -name '*.a' -or -executable \) -print0
    )

    if [[ ! -f $out ]]; then
      if ! "$any_cuobj_found"; then
        >&2 echo "ERROR: No cuda objects was found in "${lib.escapeShellArg package.name}"!"
      else
        >&2 echo "ERROR: No binary satisfying all requirement was found in "${lib.escapeShellArg package.name}"!"
      fi
      exit 1
    fi
  ''
