{
  keymap-drawer,
  runCommandWith,
  testers,

  libxml2,
  xmlstarlet,
  yamllint,
  yq-go,
}:
let
  runKeymapDrawer =
    { name, ... }@args:
    runCommandWith {
      name = "${keymap-drawer.name}-${name}";
      derivationArgs = removeAttrs args [ "name" ] // {
        nativeBuildInputs = [ keymap-drawer ] ++ args.nativeBuildInputs or [ ];
      };
    };
in
{
  dump-config =
    runKeymapDrawer
      {
        name = "dump-config";
        nativeBuildInputs = [
          yamllint
        ];
      }
      /* bash */ ''
        keymap dump-config --output "$out"

        if [ ! -s "$out" ]; then
          >&2 echo 'Expected `dump-config` to have content.'
          exit 1
        fi

        yamllint --strict --config-data relaxed "$out"
      '';

  invalid-keymap = testers.testBuildFailure (
    runKeymapDrawer
      {
        name = "invalid-keymap";
      }
      /* bash */ ''
        keymap \
          --config ${./config.yaml} \
          parse --zmk-keymap ${./invalid.keymap} \
          --output "$out"
      ''
  );

  parse-zmk =
    runKeymapDrawer
      {
        name = "parse";
        nativeBuildInputs = [
          yamllint
          yq-go
        ];
      }
      /* bash */ ''
        keymap \
          --config ${./config.yaml} \
          parse --zmk-keymap ${./minimal.keymap} \
          --output "$out"

        yamllint --strict --config-data relaxed "$out" || {
          >&2 echo "Malformed YAML"
          exit 1
        }

        layer_count=$(yq '.layers | length' "$out")
        (( layer_count == 2 )) || {
          >&2 echo "Expected 2 layers, found $layer_count"
          exit 1
        }

        default_layer=$(yq --exit-status '.layers.default | flatten' "$out") || {
          >&2 echo "Expected default layer"
          exit 1
        }

        fn_layer=$(yq --exit-status '.layers.fn | flatten' "$out") || {
          >&2 echo "Expected fn layer"
          exit 1
        }

        [ "$default_layer" = '[ESC, A, B, SPACE, C, D]' ] || {
          >&2 echo "Incorrect default layer: $default_layer"
          exit 1
        }

        [ "$fn_layer" = '[F1, F2, F3, F4, F5, F6]' ] || {
          >&2 echo "Incorrect fn layer: $fn_layer"
          exit 1
        }

        yq --exit-status '.. | select(. == "ESC")' "$out" >/dev/null || {
          >&2 echo "Expected 'ESC' key"
          exit 1
        }

        yq --exit-status '.. | select(. == "SPACE")' "$out" >/dev/null || {
          >&2 echo "Expected 'SPACE' key"
          exit 1
        }

        yq --exit-status '.. | select(. == "F1")' "$out" >/dev/null || {
          >&2 echo "Expected 'F1' key"
          exit 1
        }
      '';

  draw =
    runKeymapDrawer
      {
        name = "draw";
        nativeBuildInputs = [
          xmlstarlet
          libxml2
        ];
      }
      /* bash */ ''
        keymap \
          --config ${./config.yaml} \
          draw ${./minimal.yaml} \
          --output "$out"

        ns="http://www.w3.org/2000/svg"

        # Basic XML validity
        xmllint --noout "$out" || {
          >&2 echo "Malformed XML"
          exit 1
        }

        # Root element is <svg>
        xmlstarlet sel -N s="$ns" -t -v "name(/s:svg)" "$out" | grep -qx svg || {
          >&2 echo "Expected <svg> root element"
          exit 1
        }

        # Assert two layers exist
        layer_count=$(xmlstarlet sel -N s="$ns" -t -v 'count(//s:g[contains(@class, "layer-")])' "$out")
        (( layer_count == 2 )) || {
          >&2 echo "Expected exactly 2 layers, found $layer_count"
          exit 1
        }

        for layer in default fn; do
          # layer-id class
          xmlstarlet sel -N s="$ns" -t -v 'count(//s:g[@class="layer-'"$layer"'"])' "$out" | grep -qx 1 || {
            >&2 echo "Missing layer-$layer class"
            exit 1
          }

          # text label
          xmlstarlet sel -N s="$ns" -t -v '//s:text[@class="label" and text()="'"$layer"':"]' "$out" | grep -q "$layer": || {
            >&2 echo "Missing $layer layer text label"
            exit 1
          }
        done

        key_count=$(xmlstarlet sel -N s="$ns" -t -v 'count(//s:g[contains(@class, "keypos-")])' "$out")
        (( key_count == 12 )) || {
          >&2 echo "Expected 12 keys total (6 per layer), found $key_count"
          exit 1
        }

        for key in ESC A B SPACE C D F1 F2 F3 F4 F5 F6; do
          xmlstarlet sel -N s="$ns" -t -v "//s:text[@class='key tap' and text()='$key']" "$out" | grep -q "$key" || {
            >&2 echo "Expected key '$key'"
            exit 1
          }
        done
      '';
}
