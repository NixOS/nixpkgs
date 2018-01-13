{ patchSet, useRailsExpress, ops, patchLevel }:

rec {
  "2.0.0" = [
    ./ssl_v3.patch
    ./rand-egd.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/02-railsexpress-gc.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
  ];
  "2.1.10" = [
    ./rand-egd.patch
  ] ++ ops useRailsExpress [
    # 2.1.10 patchsets are not available, but 2.1.8 patchsets apply
    "${patchSet}/patches/ruby/2.1.8/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/05-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/06-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/07-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/08-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.8/railsexpress/09-heap-dump-support.patch"
  ];
  "2.2.9" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2/head/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.3.6" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.3/head/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.4.3" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.4/head/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.4/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.4/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
}
