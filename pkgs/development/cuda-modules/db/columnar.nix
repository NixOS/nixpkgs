let
  lib = import ../../../../lib;
  inherit (lib.types) attrsOf enum;
in
rec {
  unit = 1;
  Unit = enum [ unit ];
  SetOfStr = attrsOf Unit;

  # ∷ Column ⇒ Type ⇒ MkOptionArgs ⇒ Option
  mkColumnOption =
    indexColumn: rowType: optionArgsCol:
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
      colNames = lib.unique (builtins.attrNames columns ++ builtins.attrNames columnDefaults);
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
      diff = lib.concatStringsSep ", " (lib.attrNames sd.onlyRight);
    in
    [
      {
        message = "${columnName} defines items outside ${indexName}: ${diff}";
        assertion = lib.all (lib.flip builtins.elem (builtins.attrNames index)) (builtins.attrNames column);
      }
    ];

  assertComplete =
    indexName: index: columnName: column:
    let
      sd = symmDiff index column;
      leftCond = sd.onlyLeft != { };
      rightCond = sd.onlyRight != { };
      left = "is missing rows ${lib.concatStringsSep ", " (lib.attrNames sd.onlyLeft)}";
      right = "defines undeclared rows ${lib.concatStringsSep ", " (lib.attrNames sd.onlyRight)}";
      errors = lib.concatStringsSep ", and" (
        lib.optionals leftCond [ left ] ++ lib.optionals rightCond [ right ]
      );
    in
    [
      {
        message = "`${columnName}' doesn't match the index `${indexName}': ${errors}";
        assertion = !leftCond && !rightCond;
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
