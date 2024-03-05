{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, sqlalchemy
, sqlbag
, setuptools
, poetry-core
, pytestCheckHook
, pytest-xdist
, pytest-sugar
, postgresql
, postgresqlTestHook
,
}:
buildPythonPackage rec {
  pname = "schemainspect";
  version = "3.1.1663587362";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "djrobstep";
    repo = pname;
    # no tags on github, version patch number is unix time.
    rev = "066262d6fb4668f874925305a0b7dbb3ac866882";
    hash = "sha256-SYpQQhlvexNc/xEgSIk8L8J+Ta+3OZycGLeZGQ6DWzk=";
  };

  patches = [
    # https://github.com/djrobstep/schemainspect/pull/87
    (fetchpatch
      {
        name = "specify_poetry.patch";
        url = "https://github.com/djrobstep/schemainspect/commit/bdcd001ef7798236fe0ff35cef52f34f388bfe68.patch";
        hash = "sha256-/SEmcV9GjjvzfbszeGPkfd2DvYenl7bZyWdC0aI3M4M=";
      })
  ];

  nativeBuildInputs = [
    poetry-core
  ];
  propagatedBuildInputs = [
    setuptools # needed for 'pkg_resources'
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-sugar

    postgresql
    postgresqlTestHook

    sqlbag
  ];

  preCheck = ''
    export PGUSER="nixbld";
    export postgresqlEnableTCP=1;
  '';
  disabledTests = [
    # These all fail with "List argument must consist only of tuples or dictionaries":
    # Related issue: https://github.com/djrobstep/schemainspect/issues/88
    "test_can_replace"
    "test_collations"
    "test_constraints"
    "test_dep_order"
    "test_enum_deps"
    "test_exclusion_constraint"
    "test_fk_col_order"
    "test_fk_info"
    "test_generated_columns"
    "test_identity_columns"
    "test_indexes"
    "test_inherit"
    "test_kinds"
    "test_lineendings"
    "test_long_identifiers"
    "test_partitions"
    "test_postgres_inspect"
    "test_postgres_inspect_excludeschema"
    "test_postgres_inspect_sigleschema"
    "test_raw_connection"
    "test_relationship"
    "test_replica_trigger"
    "test_rls"
    "test_separate_validate"
    "test_sequences"
    "test_table_dependency_order"
    "test_types_and_domains"
    "test_view_trigger"
    "test_weird_names"
  ];

  pytestFlagsArray = [
    "-x"
    "-svv"
    "tests"
  ];
  pythonImportsCheck = [
    "schemainspect"
  ];

  postUnpack = ''
    # this dir is used to bump the version number, having it here fails the build
    rm -r ./source/deploy
  '';

  meta = with lib; {
    description = "Schema inspection for PostgreSQL, and potentially others";
    homepage = "https://github.com/djrobstep/schemainspect";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ soispha ];
  };
}
