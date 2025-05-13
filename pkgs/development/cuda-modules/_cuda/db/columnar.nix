let
  lib = import libPath;
  inherit (import ./nixpkgs_paths.nix) libPath;
  inherit (lib.types) attrsOf enum;
in
rec {
  unit = true;
  Unit = enum [ unit ];
  SetOfStr = attrsOf Unit;
  listToSetOfStr = lib.flip lib.genAttrs (lib.const unit);

  # ∷ attrsOf Unit ⇒ Type ⇒ MkOptionArgs ⇒ Option
  #
  # The first argument is kept for compatibility with the original intent of
  # introducing assertions at declaration site.
  mkColumnOption =
    _index: rowType: optionArgsCol:
    lib.mkOption (
      optionArgsCol
      // {
        type = attrsOf rowType;
      }
    );

  # ∷ ColumnName ⇒ (AttrsOf Any) ⇒ (AttrsOf Column) ⇒ (AttrsOf Column)
  defaults =
    indexColumn: columnDefaults: columns:
    let
      rowNames = builtins.attrNames columns.${indexColumn};
      colNames = builtins.attrNames (columnDefaults // columns);
    in
    columns
    // lib.listToAttrs (
      lib.concatMap (
        columnName:
        let
          default = columnDefaults.${columnName};
          column = columns.${columnName} or { };
        in
        lib.optional (columnName != indexColumn) {
          name = columnName;
          value = lib.genAttrs rowNames (n: column.${n} or default);
        }
      ) colNames
    );

  symmDiff = left: right: {
    onlyLeft = lib.filterAttrs (name: _: !(lib.hasAttr name right)) left;
    onlyRight = lib.filterAttrs (name: _: !(lib.hasAttr name left)) right;
  };

  assertSubset =
    indexName: index: columnName: column:
    let
      sd = symmDiff index column;
      undeclaredMsg = lib.concatStringsSep ", " (lib.attrNames sd.onlyRight);
    in
    [
      {
        message = "${columnName} defines undeclared rows (index: ${indexName}): ${undeclaredMsg}";
        assertion = lib.all (lib.flip builtins.elem (builtins.attrNames index)) (builtins.attrNames column);
      }
    ];

  assertComplete =
    indexName: index: columnName: column:
    let
      sd = symmDiff index column;
      anyMissing = sd.onlyLeft != { };
      anyUndeclared = sd.onlyRight != { };
      missingMsg = "is missing rows ${lib.concatStringsSep ", " (lib.attrNames sd.onlyLeft)}";
      undeclaredMsg = "defines undeclared rows ${lib.concatStringsSep ", " (lib.attrNames sd.onlyRight)}";
      errors = lib.concatStringsSep ", and" (
        lib.optionals anyMissing [ missingMsg ] ++ lib.optionals anyUndeclared [ undeclaredMsg ]
      );
    in
    [
      {
        message = "`${columnName}' doesn't match the index `${indexName}': ${errors}";
        assertion = !anyMissing && !anyUndeclared;
      }
    ];
  assertCompleteTable =
    indexName: columns:
    lib.concatMap (
      name:
      lib.optionals (name != indexName) (
        assertComplete indexName columns.${indexName} name columns.${name}
      )
    ) (lib.attrNames columns);
}
