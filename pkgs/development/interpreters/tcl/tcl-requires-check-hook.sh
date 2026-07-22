# Setup hook for checking whether Tcl requires succeed
echo "Sourcing tcl-requires-check-hook.sh"

tclRequiresCheckPhase () {
    echo "Executing tclRequiresCheckPhase"

    if [ -n "$tclRequiresCheck" ]; then
        export TCLLIBPATH="$out/lib $TCLLIBPATH" # Redundant if tcl-package-hook is also used
        tclsh <<'EOF'
          if {[info exists env(NIX_ATTRS_JSON_FILE)]} {
            set nix_attrs_json_file [open $env(NIX_ATTRS_JSON_FILE)]
            set nix_attrs_json [read $nix_attrs_json_file]
            close $nix_attrs_json_file
            # Normally we'd use one of tcllib/tdom/rl_json/yajl-tcl to parse JSON,
            # however we don't want to introduce a circular dependency,
            # so we rely on the JSON capabilities of the builtin sqlite package
            # https://wiki.tcl-lang.org/page/SQLite+extension+JSON1
            package require sqlite3
            sqlite3 db :memory: -readonly 1
            set packages_to_check [db eval {
              select value from json_each(jsonb_extract($nix_attrs_json, '$.tclRequiresCheck'))
            }]
            db close
          } else {
            set packages_to_check $env(tclRequiresCheck)
          }
          puts "Check whether the following packages can be required: $packages_to_check"
          exit [catch {foreach pkg $packages_to_check {package require $pkg}}]
EOF
    fi
}

if [ -z "${dontUseTclRequiresCheck-}" ]; then
    echo "Using tclRequiresCheckPhase"
    preDistPhases+=" tclRequiresCheckPhase"
fi
