{ patchSet, useRailsExpress, ops, patchLevel }:

rec {
  "2.3.8" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.3/head/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.4.5" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.4/head/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.4/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.4/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.5.5" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.5/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.5/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.5/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "2.6.3" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.6/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
}
