let
  lib = import ../../../../lib;
in
{
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

  # :: ColumnName -> (AttrsOf Column) -> List { message :: Str, assertion: Bool }
  domainAssertions =
    tableName: indexColumnName: columns:
    let
      indexColumn = columns.${indexColumnName};
      names = builtins.attrNames indexColumn;
    in
    lib.concatMap (
      columnName:
      let
        column = lib.addErrorContext "While validating column ${columnName}" columns.${columnName};
        newNames = builtins.attrNames column;
        missing = builtins.filter (name: !(lib.hasAttr name column)) names;
        unexpected = builtins.filter (name: !(lib.hasAttr name indexColumn)) newNames;
        symDiff = missing ++ unexpected;
        missingStr = lib.optionalString (missing != [ ]) " missing ${lib.concatStringsSep ", " missing}";
        unexpectedStr = lib.optionalString (
          unexpected != [ ]
        ) " unexpected ${lib.concatStringsSep ", " unexpected}";
      in
      lib.optionals (indexColumnName != columnName) [
        {
          message = "${tableName}.${columnName}'s domain doesn't match ${indexColumnName}:${missingStr}${unexpectedStr}";
          assertion = symDiff == [ ];
        }
      ]
    ) (builtins.attrNames columns);
}
