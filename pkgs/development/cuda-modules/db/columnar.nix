let
  lib = import ../../../../lib;
  inherit (lib.types) attrsOf enum submodule;

  unit = 1;
  Unit = enum [ unit ];
in
{
  inherit unit Unit;
  SetOfStr = attrsOf Unit;

  # :: Column -> MkOptionArgs -> MkOptionArgs -> Option
  mkColumnOption =
    indexColumn: optionArgsRow: optionArgsCol:
    lib.mkOption (
      optionArgsCol
      // {
        type = submodule { options = lib.mapAttrs (name: _: lib.mkOption optionArgsRow) indexColumn; };
      }
    );

  # :: ColumnName -> (AttrsOf Any) -> (AttrsOf Column) -> (AttrsOf Column)
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

  assertSubset = indexName: index: tableName: table: [
    {
      message = "${tableName} defines items outside ${indexName}";
      assertion = lib.all (lib.flip builtins.elem (builtins.attrNames index)) (builtins.attrNames table);
    }
  ];
}
